From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] msync: fix incorrect fstart calculation
Date: Fri, 27 Jun 2014 12:12:56 -0400
Message-ID: <20140627161256.GA8164@wallace>
References: <006a01cf91fc$5d225170$1766f450$@samsung.com>
 <100D68C7BA14664A8938383216E40DE0407A787B@FMSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Namjae Jeon <namjae.jeon@samsung.com>,
	'Andrew Morton' <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	'Eric Whitney' <enwlinux@gmail.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <100D68C7BA14664A8938383216E40DE0407A787B@FMSMSX114.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

I can confirm that this patch corrects the ext4 regressions I reported on
3.16-rc1 for data_journal.

Additionally, it corrects regressions for two other tests I have not yet
reported.  Those tests include generic/263 when running with the
data=3Djournal mount option, and generic/219 (a quota test that doesn't u=
se
fsx) when running with all xfstests-bld scenarios (4k, ext4, nojournal, 1=
k,
etc.) with the exception of bigalloc.  The generic/219 failure on bigallo=
c in
3.16-rc1 is not a regression, and was present in earlier releases.

With this patch, ext4 3.16-rc3 regression results on x64_64 should look m=
uch
more like 3.15 final.

Thanks guys!
Eric


* Wilcox, Matthew R <matthew.r.wilcox@intel.com>:
> Acked-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> ________________________________________
> From: Namjae Jeon [namjae.jeon@samsung.com]
> Sent: June 27, 2014 4:38 AM
> To: 'Andrew Morton'
> Cc: linux-mm@kvack.org; linux-ext4; Luk=C3=A1=C5=A1 Czerner; Wilcox, Ma=
tthew R; 'Eric Whitney'; Ashish Sangwan
> Subject: [PATCH] msync: fix incorrect fstart calculation
>=20
> Fix a regression caused by Commit 7fc34a62ca mm/msync.c: sync only
> the requested range in msync().
> xfstests generic/075 fail occured on ext4 data=3Djournal mode because
> the intended range was not syncing due to wrong fstart calculation.
>=20
> Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
> Cc: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
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
>                         goto out_unlock;
>                 }
>                 file =3D vma->vm_file;
> -               fstart =3D start + ((loff_t)vma->vm_pgoff << PAGE_SHIFT=
);
> +               fstart =3D (start - vma->vm_start) +
> +                        ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
>                 fend =3D fstart + (min(end, vma->vm_end) - start) - 1;
>                 start =3D vma->vm_end;
>                 if ((flags & MS_SYNC) && file &&
> --
> 1.7.11-rc0
>=20

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
