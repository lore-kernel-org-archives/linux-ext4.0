From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 1/7][TAKE5] fallocate() implementation on i386, x86_64 and powerpc
Date: Tue, 26 Jun 2007 21:38:55 +0200
Message-ID: <20070626193855.GA13727@osiris.ibm.com>
References: <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134012.GB1951@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
	Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com,
	cmm@us.ibm.com, xfs@oss.sgi.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070625134012.GB1951@amitarora.in.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> Index: linux-2.6.22-rc4/arch/powerpc/kernel/sys_ppc32.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/arch/powerpc/kernel/sys_ppc32.c
> +++ linux-2.6.22-rc4/arch/powerpc/kernel/sys_ppc32.c
> @@ -773,6 +773,13 @@ asmlinkage int compat_sys_truncate64(con
>  	return sys_truncate(path, (high << 32) | low);
>  }
> 
> +asmlinkage long compat_sys_fallocate(int fd, int mode, u32 offhi, u32 offlo,
> +				     u32 lenhi, u32 lenlo)
> +{
> +	return sys_fallocate(fd, mode, ((loff_t)offhi << 32) | offlo,
> +			     ((loff_t)lenhi << 32) | lenlo);
> +}
> +
>  asmlinkage int compat_sys_ftruncate64(unsigned int fd, u32 reg4, unsigned long high,
>  				 unsigned long low)
>  {
> Index: linux-2.6.22-rc4/arch/x86_64/ia32/ia32entry.S
> ===================================================================
> --- linux-2.6.22-rc4.orig/arch/x86_64/ia32/ia32entry.S
> +++ linux-2.6.22-rc4/arch/x86_64/ia32/ia32entry.S
> @@ -719,4 +719,5 @@ ia32_sys_call_table:
>  	.quad compat_sys_signalfd
>  	.quad compat_sys_timerfd
>  	.quad sys_eventfd
> +	.quad sys_fallocate
>  ia32_syscall_end:

Btw. this is also (still?) broken. x86_64 needs a compat syscall here.
