From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] readahead.2: don't claim the call blocks until all data
 has been read
Date: Sat, 15 Mar 2014 10:05:14 +0100
Message-ID: <532417CA.1040300@gmail.com>
References: <1394812471-9693-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Corrado Zoccolo <czoccolo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"Gregory P. Smith" <gps-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
	Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Phillip Susi <psusi-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394812471-9693-1-git-send-email-psusi-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

[CC +=3D Past reporters: Corrado Zoccolo, Greg Smith, Zhu Yanhai]

On 03/14/2014 04:54 PM, Phillip Susi wrote:
> The readahead(2) man page was claiming that the call blocks until all
> data has been read into the cache.  This is incorrect.

Phillip, thanks for a good patch that sums things up. I didn't follow
up an earlier patch from Greg Smith, but that patch failed to explain t=
he
behavior we discussed in https://bugzilla.kernel.org/show_bug.cgi?id=3D=
54271
where call did sometimes block for a considerable time.

I've applied the patch. Thanks for your efforts and persistence.

I've tweaked your text a bit to make some details clearer (I hope):

       readahead()  initiates  readahead  on a file so that subsequent
       reads from that file will, be satisfied from the cache, and not
       block  on  disk I/O (assuming the readahead was initiated early
       enough and that other activity on the system  did  not  in  the
       meantime flush pages from the cache).

       ...

       readahead()  attempts  to  schedule the reads in the background
       and return immediately.  However, it may block while  it  reads
       the  filesystem metadata needed to locate the requested blocks.
       This occurs frequently with ext[234] on large files using indi=E2=
=80=90
       rect  blocks instead of extents, giving the appearence that the
       call blocks until the requested data has been read.

Okay?

Cheers,

Michael
=20
> Signed-off-by: Phillip Susi <psusi-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> ---
>  man2/readahead.2 | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>=20
> diff --git a/man2/readahead.2 b/man2/readahead.2
> index 605fa5e..1b0376e 100644
> --- a/man2/readahead.2
> +++ b/man2/readahead.2
> @@ -27,7 +27,7 @@
>  .\"
>  .TH READAHEAD 2 2013-04-01 "Linux" "Linux Programmer's Manual"
>  .SH NAME
> -readahead \- perform file readahead into page cache
> +readahead \- initiate file readahead into page cache
>  .SH SYNOPSIS
>  .nf
>  .BR "#define _GNU_SOURCE" "             /* See feature_test_macros(7=
) */"
> @@ -37,8 +37,8 @@ readahead \- perform file readahead into page cache
>  .fi
>  .SH DESCRIPTION
>  .BR readahead ()
> -populates the page cache with data from a file so that subsequent
> -reads from that file will not block on disk I/O.
> +initates readahead on a file so that subsequent reads from that file=
 will
> +hopefully be satisfied from the cache, and not block on disk I/O.
>  The
>  .I fd
>  argument is a file descriptor identifying the file which is
> @@ -57,8 +57,6 @@ equal to
>  .IR "(offset+count)" .
>  .BR readahead ()
>  does not read beyond the end of the file.
> -.BR readahead ()
> -blocks until the specified data has been read.
>  The current file offset of the open file referred to by
>  .I fd
>  is left unchanged.
> @@ -94,6 +92,13 @@ On some 32-bit architectures,
>  the calling signature for this system call differs,
>  for the reasons described in
>  .BR syscall (2).
> +
> +The call attempts to schedule the reads in the background and return
> +immediately, however it may block while reading filesystem metadata
> +in order to locate where the blocks requested are.  This occurs freq=
uently
> +with ext[234] on large files using indirect blocks instead of extent=
s,
> +giving the appearence that the call blocks until the requested data =
has
> +been read.
>  .SH SEE ALSO
>  .BR lseek (2),
>  .BR madvise (2),
>=20


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
