From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Use ext2fs_flush() only once
Date: Tue, 13 Sep 2011 22:58:43 -0400
Message-ID: <20110914025843.GA3429@dhcp-172-31-195-159.cam.corp.google.com>
References: <1311941612-9108-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42645 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab1INMlw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 08:41:52 -0400
Content-Disposition: inline
In-Reply-To: <1311941612-9108-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied, with an obvious bugfix:

> -void print_check_message(ext2_filsys fs)
> +void print_check_message(unsigned int mnt, unsigned int check)
>  {
>  	printf(_("This filesystem will be automatically "
>  		 "checked every %d mounts or\n"
>  		 "%g days, whichever comes first.  "
>  		 "Use tune2fs -c or -i to override.\n"),
> -	       fs->super->s_max_mnt_count,
> -	       (double)fs->super->s_checkinterval / (3600 * 24));
> +		mnt, check / (3600 * 24));
>  }

=2E./../misc/util.c: In function =E2=80=98print_check_message=E2=80=99:
=2E./../misc/util.c:291: warning: format =E2=80=98%g=E2=80=99 expects t=
ype =E2=80=98double=E2=80=99, but argument 3 has type =E2=80=98unsigned=
 int=E2=80=99

the (double) cast was dropped in your patch.

The message should be made a bit better in the case that
s_max_mnt_count or s_checkinterval is zero, but that's a separate
patch.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
