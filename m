From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 18/49] misc: fix header complaints and resource leaks in
 e2fsprogs
Date: Fri, 14 Mar 2014 09:39:31 -0400
Message-ID: <20140314133931.GM8282@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065553.30585.86527.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41369 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbaCNNje (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2014 09:39:34 -0400
Content-Disposition: inline
In-Reply-To: <20140311065553.30585.86527.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:55:53PM -0700, Darrick J. Wong wrote:
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index b39383d..11c2693 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1016,6 +1016,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
>  			strcat(newpath, oldpath);
>  		}
>  		putenv(newpath);
> +		free(newpath);
>  	}

This introduces a bug.  An attempt to reference the PATH environment
variable will result in garbage or a crash.  Quoting from the putenv()
manpage:

   The putenv() function adds or changes the value of environment
   variables.  The argument string is of the form name=value.  If name
   does not already exist in the environment, then string is added to
   the environment.  If name does exist, then the value of name in the
   environment is changed to value.  The string pointed to by string
   becomes part of the environment, so altering the string changes the
   environment.

It's a common false positive with things like cppcheck, valgrind
--leak-check, etc.

Cheers,

						- Ted
