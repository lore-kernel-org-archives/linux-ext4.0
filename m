From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH 1/1] fs: Small refactoring of the code in ext4
 2.6.37-rc1
Date: Thu, 4 Nov 2010 23:31:58 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1011042320170.16015@swampdragon.chaosbits.net>
References: <250707.83204.qm@web110504.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-55086022-1288909876=:16015"
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: =?ISO-8859-15?Q?Andr=E9_Luis_Pereira_dos_Santos_-_BSRSoft?=
	<andre@bsrsoft.com.br>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <250707.83204.qm@web110504.mail.gq1.yahoo.com>
Content-ID: <alpine.LNX.2.00.1011042331200.16015@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-55086022-1288909876=:16015
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.1011042331201.16015@swampdragon.chaosbits.net>

On Thu, 4 Nov 2010, André Luis Pereira dos Santos - BSRSoft wrote:

> From: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
> 
> Hi.
> Small refactoring of the code in order to make minor enhancements to critical areas.
> The notation x + 1 has been replaced by more efficient notation x + +.
> 
> Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
> ---
> Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
> --- linux-2.6.37-rc1/fs/ext4/extents.c	2010-11-01 09:54:12.000000000 -0200
> +++ linux-2.6.37-rc1-patched/fs/ext4/extents.c	2010-11-04 19:54:26.000000000 -0200
> @@ -555,9 +555,9 @@ ext4_ext_binsearch(struct inode *inode,
>  	while (l <= r) {
>  		m = l + (r - l) / 2;
>  		if (block < le32_to_cpu(m->ee_block))
> -			r = m - 1;
> +			r = m--;
>  		else
> -			l = m + 1;
> +			l = m++;

These do not give identical results.

foo = bar + 1;  assigns (bar + 1) to foo.
foo = bar--;  assigns bar to foo then decrements bar.
foo = --bar;  decrements bar then assigns bar to foo.

So your change both change the value that will be assigned to 'r' and 'l' 
and also modify 'm' which was not previously modified.


>  		ext_debug("%p(%u):%p(%u):%p(%u) ", l, le32_to_cpu(l->ee_block),
>  				m, le32_to_cpu(m->ee_block),
>  				r, le32_to_cpu(r->ee_block));
> @@ -1557,7 +1557,7 @@ static int ext4_ext_try_to_merge(struct
>  		if (ext4_ext_is_uninitialized(ex))
>  			uninitialized = 1;
>  		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
> -				+ ext4_ext_get_actual_len(ex + 1));
> +				+ ext4_ext_get_actual_len(ex++));

After your change gcc complains:

 fs/ext4/extents.c:1559:16: warning: operation on ‘ex’ may be undefined
 fs/ext4/extents.c:1559:16: warning: operation on ‘ex’ may be undefined

which it is correct in doing since you are now modifying the value of the 
pointer which is dereferenced in the assignment. Previously the value of 
(ex+1) was simply passed to ext4_ext_get_actual_len(), but now you are 
passing the value of (ex) to ext4_ext_get_actual_len() and then 
subsequently incrementing 'ex' itself.


>  		if (uninitialized)
>  			ext4_ext_mark_uninitialized(ex);
> 
> 


Was this patch even compile tested?

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
--8323328-55086022-1288909876=:16015--
