From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] kvm-xfstests: add initrd support
Date: Fri, 19 Aug 2016 09:44:32 -0400
Message-ID: <20160819134432.GH10888@thunk.org>
References: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org>
 <1471553651-9547-6-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45618 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753928AbcHSNpH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 19 Aug 2016 09:45:07 -0400
Content-Disposition: inline
In-Reply-To: <1471553651-9547-6-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 19, 2016 at 12:54:10AM +0400, Dmitry Monakhov wrote:
> +	--initrd) shift
> +		  INITRD="$1"
> +		  if test ! -f "$INITRD" ; then
> +		      print_help
> +		  fi
> +		  ;;

We should only allow --initrd for kvm-xfstests, or add support for
uploading the initrd to gce-xfstests, and then adding support to it to
the gce-kexec script.

We can just allow it for kvm-xfstests first, and then only later add
support to gce-xfstests, if you don't have time to work to get
gce-xfstests support for --initrd working.

Cheers,

						- Ted

