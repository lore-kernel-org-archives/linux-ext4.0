From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/6] xfstest: add fio git submodule
Date: Sun, 23 Sep 2012 22:16:57 -0500
Message-ID: <505FD0A9.3090601@redhat.com>
References: <a> <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, hch@lst.de
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab2IXDRJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Sep 2012 23:17:09 -0400
In-Reply-To: <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/23/12 2:24 PM, Dmitry Monakhov wrote:
> FIO is very flexible io generator, i would call it IO swiss knife.
> Currently we have tonnes of hardcoded application which reproduces
> some predefined scenario. This approach has obvious dissadvantages
> 1) Lack of flexability: once written it is hard to modify it in future
> 2) Code base is large, many routines written again and again
> 
> At the same time add new fio based tast is just add simle INI file.
> This greatly simplify code review. I do beleve that some day we will
> replace most of hardcoded io binaries with fio.

The submodule approach is interesting, but I wonder - we have quite a few
dependencies on other binaries already; what are the pros and cons of creating
this as a git submodule vs. simply expecting fio to be installed on the
system like any of the other dependencies we have today?

(I package fio for Fedora, is it not commonly available on other
distros?)

-Eric

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  .gitmodules                  |    3 +++
>  common.config                |    3 +++
>  src/Makefile                 |    8 +++++---
>  src/aio-dio-regress/Makefile |    4 ++--
>  src/fio                      |    1 +
>  5 files changed, 14 insertions(+), 5 deletions(-)
>  create mode 100644 .gitmodules
>  create mode 160000 src/fio
> 
> diff --git a/.gitmodules b/.gitmodules
> new file mode 100644
> index 0000000..f0481ea
> --- /dev/null
> +++ b/.gitmodules
> @@ -0,0 +1,3 @@
> +[submodule "src/fio"]
> +	path = src/fio
> +	url = git://git.kernel.dk/fio.git
> diff --git a/common.config b/common.config
> index 7bed1c5..25cddb4 100644
> --- a/common.config
> +++ b/common.config
> @@ -138,6 +138,9 @@ export DF_PROG="`set_prog_path df`"
>  [ "$DF_PROG" = "" ] && _fatal "df not found"
>  [ "$HOSTOS" = "Linux" ] && export DF_PROG="$DF_PROG -T"
>  
> +export FIO_PROG="`set_prog_path $PWD/src/fio/fio`"
> +[ "$FIO_PROG" = "" ] && _fatal "fio not found"
> +
>  export XFS_LOGPRINT_PROG="`set_prog_path xfs_logprint`"
>  export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
>  export XFS_CHECK_PROG="`set_prog_path xfs_check`"
> diff --git a/src/Makefile b/src/Makefile
> index 67250ee..255bdd4 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -52,16 +52,18 @@ LLDLIBS += $(LIBGDBM)
>  endif
>  
>  ifeq ($(HAVE_AIO), true)
> -SUBDIRS += aio-dio-regress
> +SUBDIRS += aio-dio-regress \
> +		fio
> +
>  endif
>  
>  CFILES = $(TARGETS:=.c)
>  LDIRT = $(TARGETS)
>  
>  
> -default: depend $(TARGETS) $(SUBDIRS)
> +default: .depend $(TARGETS) $(SUBDIRS)
>  
> -depend: .dep
> +.depend: .dep
>  
>  include $(BUILDRULES)
>  
> diff --git a/src/aio-dio-regress/Makefile b/src/aio-dio-regress/Makefile
> index 79dd55d..fcead9a 100644
> --- a/src/aio-dio-regress/Makefile
> +++ b/src/aio-dio-regress/Makefile
> @@ -8,9 +8,9 @@ LDIRT = $(TARGETS)
>  
>  LLDLIBS = -laio -lpthread
>  
> -default: depend $(TARGETS)
> +default: .depend $(TARGETS)
>  
> -depend: .dep
> +.depend: .dep
>  
>  include $(BUILDRULES)
>  
> diff --git a/src/fio b/src/fio
> new file mode 160000
> index 0000000..e12d280
> --- /dev/null
> +++ b/src/fio
> @@ -0,0 +1 @@
> +Subproject commit e12d2800f811cb64d376cfdaed9a1257f3fa9c99
> 

