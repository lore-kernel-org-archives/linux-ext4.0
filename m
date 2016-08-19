From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6] kvm-xfstests: update command line help
Date: Fri, 19 Aug 2016 09:42:38 -0400
Message-ID: <20160819134238.GG10888@thunk.org>
References: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org>
 <1471553651-9547-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45592 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754567AbcHSNmq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 19 Aug 2016 09:42:46 -0400
Content-Disposition: inline
In-Reply-To: <1471553651-9547-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 19, 2016 at 12:54:08AM +0400, Dmitry Monakhov wrote:
> diff --git a/kvm-xfstests/util/parse_cli b/kvm-xfstests/util/parse_cli
> index 83400ea..edbbafa 100644
> --- a/kvm-xfstests/util/parse_cli
> +++ b/kvm-xfstests/util/parse_cli
> @@ -26,10 +26,47 @@ print_help ()
>      echo "	-o opts		- Extra kernel command line options"
>      echo "	-r ram		- Specify memory to be used in megabytes"
>      echo "	-X test		- Exclude test from running"
> +    echo "	--no-punch	- Do not run tests w/ patch hole"
> +    echo "	--no-collapse	- Do not run tests w/ collapse range"
> +    echo "	--no-insert	- Do not run tests w/ insert range"
> +    echo "	--no-zero	- Do not run tests w/ zero range"

The reason why I don't document these options is they depend on an
out-of-tree patch for xfstests.  It's in my githup repo, but it's not
something which xfstests upstream has seen fit to take.

>      if test "$GCE_XFSTESTS" != "yes" ; then
>  	echo "	--kernel file	- Boot the specified kernel"
>  
> +    else
> +	echo "GCE speciffic commands:"
> +	echo "	ls-instances"
> +        echo "	ls|ls-instances"
> +        echo "	rm|rm-instances|abort|abort-instances"
> +        echo "	start|start-instance|start-instances"
> +        echo "	stop|stop-instance|stop-instances"
> +        echo "	ls-disks|ls-disk"
> +        echo "	rm-disks|rm-disk"
> +        echo "	ls-results|ls-gcs"
> +        echo "	rm-results|rm-gcs"
> +        echo "	get-results"
> +        echo "	setup"
> +        echo "	ssh"
> +        echo "	console"
> +        echo "	serial"
> +        echo "	get-results"
> +        echo "	create-image"
> +        echo "	export-image"
> +        echo "	import-image"
> +        echo "	--numa"
> +        echo "	--log"
> +        echo "	--local-ssd"
> +        echo "	--pmem-device"
> +        echo "	--machtype"
> +        echo "	--image-project"
> +        echo "	--instance-name"
> +        echo "	--no-virtio-rng"
>      fi
> +    echo "Base image update commands:"
> +    echo "	--update-xfstests-tar"
> +    echo "	--update-xfstests"
> +    echo "	--update-files"
> +    echo
>      echo "	--no-log	- Don't save the log file for this run"
>      echo "	--no-action	- Print the command to start the VM"
>      echo ""

The options don't belong next to the GCE specific commands.  And
gce-import, as well as the base image update options, are really
intended for the maintainer (e.g., for me to update the xfstests-cloud
public image project).

The main issue is I'm a bit concerned about making the help message
too long.  My long term vision is to go in the direction of git and
gcloud's style of help messages / man pages.  So gce-xfstests --help
and kvm-xfstests --help will display a list of the most commonly used
/ useful commands and options.  And where "gce-xfstests get-results
--help" will display a full man page for the get-results subcommand,
and "gce-xfstests help commands" will display a full list of all
commands, and "gce-xfstests help topics" will allow you to see the
documentation currently available as markdown files in Documentation.

Cheers,

						- Ted
