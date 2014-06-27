From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] msync: fix incorrect fstart calculation
Date: Fri, 27 Jun 2014 13:51:11 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406271348150.2349@localhost.localdomain>
References: <006a01cf91fc$5d225170$1766f450$@samsung.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1417942477-1403869875=:2349"
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        "'Matthew Wilcox'" <matthew.r.wilcox@intel.com>,
        "'Eric Whitney'" <enwlinux@gmail.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <006a01cf91fc$5d225170$1766f450$@samsung.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1417942477-1403869875=:2349
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Jun 2014, Namjae Jeon wrote:

> Date: Fri, 27 Jun 2014 20:38:49 +0900
> From: Namjae Jeon <namjae.jeon@samsung.com>
> To: 'Andrew Morton' <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org, linux-ext4 <linux-ext4@vger.kernel.org>,
>     Luk=E1=B9 Czerner <lczerner@redhat.com>,
>     'Matthew Wilcox' <matthew.r.wilcox@intel.com>,
>     'Eric Whitney' <enwlinux@gmail.com>,
>     Ashish Sangwan <a.sangwan@samsung.com>
> Subject: [PATCH] msync: fix incorrect fstart calculation
>=20
> Fix a regression caused by Commit 7fc34a62ca mm/msync.c: sync only
> the requested range in msync().
> xfstests generic/075 fail occured on ext4 data=3Djournal mode because
> the intended range was not syncing due to wrong fstart calculation.

Looks good to me and it fixes the issues with data=3Djournal on ext4.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Tested-by: Lukas Czerner <lczerner@redhat.com>

>=20
> Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
> Cc: Luk=E1=B9 Czerner <lczerner@redhat.com>
> Reported-by: Eric Whitney <enwlinux@gmail.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  mm/msync.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/mm/msync.c b/mm/msync.c
> index a5c6736..ad97dce 100644
> --- a/mm/msync.c
> +++ b/mm/msync.c
> @@ -78,7 +78,8 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, =
len, int, flags)
>  			goto out_unlock;
>  		}
>  		file =3D vma->vm_file;
> -		fstart =3D start + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
> +		fstart =3D (start - vma->vm_start) +
> +			 ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
>  		fend =3D fstart + (min(end, vma->vm_end) - start) - 1;
>  		start =3D vma->vm_end;
>  		if ((flags & MS_SYNC) && file &&
>=20
--8323328-1417942477-1403869875=:2349--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
