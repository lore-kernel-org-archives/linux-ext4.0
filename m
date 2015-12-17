From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: Ideas on unified real-ro mount option across all filesystems
Date: Thu, 17 Dec 2015 09:58:32 +0800
Message-ID: <567216C8.5090304@cn.fujitsu.com>
References: <567212DA.8050808@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: btrfs <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>
To: fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <567212DA.8050808@cn.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

And here is the existing discussion in btrfs mail list, just for reference:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/51098

Thanks,
Qu

Qu Wenruo wrote on 2015/12/17 09:41 +0800:
> Hi,
>
> In a recent btrfs patch, it is going to add a mount option to disable
> log replay for btrfs, just like "norecovery" for ext4/xfs.
>
> But in the discussion on the mount option name and use case, it seems
> better to have an unified and fs independent mount option alias for real
> RO mount
>
> Reasons:
> 1) Some file system may have already used [no]"recovery" mount option
>     In fact, btrfs has already used "recovery" mount option.
>     Using "norecovery" mount option will be quite confusing for btrfs.
>
> 2) More straight forward mount option
>     Currently, to get real RO mount, for ext4/xfs, user must use -o
>     ro,norecovery.
>     Just ro won't ensure real RO, and norecovery can't be used alone.
>     If we have a simple alias, it would be much better for user to use.
>     (it maybe done just in user space mount)
>
>     Not to mention some fs (yeah, btrfs again) doesn't have "norecovery"
>     but "nologreplay".
>
> 3) A lot of user even don't now mount ro can still modify device
>     Yes, I didn't know this point until I checked the log replay code of
>     btrfs.
>     Adding such mount option alias may raise some attention of users.
>
>
> Any ideas about this?
>
> Thanks,
> Qu
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


