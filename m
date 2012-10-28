From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Fsck and large file
Date: Sun, 28 Oct 2012 12:01:51 -0600
Message-ID: <DA3F5378-41F1-4A3D-BA1D-C40FEBBE3B19@dilger.ca>
References: <0408C81F72528E40A0D3235A1F67FFC83ECD45F3@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Nelson, John R" <John_Nelson@student.uml.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail129c7-2520.megamailservers.com ([69.49.98.24]:49179 "EHLO
	mail129c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753948Ab2J1SBs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Oct 2012 14:01:48 -0400
In-Reply-To: <0408C81F72528E40A0D3235A1F67FFC83ECD45F3@SN2PRD0202MB144.namprd02.prod.outlook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-10-28, at 6:00, "Nelson, John R" <John_Nelson@student.uml.edu> wrote:

> How big of a file does FSCK consider a large file? I mean by the output snipplet below

That is 2GB, which is the limit beyond which the file size needs to also use the i_size_high field to store the file size. In days of yore, this was a change of the on-disk format, and e2fsck needed to either support that or refuse to check the filesystem. 

Cheers, Andreas

>  18713 inodes used (0.03%, out of 59727872)
>         248 non-contiguous files (1.3%)
>          29 non-contiguous directories (0.2%)
>             # of inodes with ind/dind/tind blocks: 0/0/0
>             Extent depth histogram: 19083/39
>    13643522 blocks used (5.71%, out of 238892544)
>           0 bad blocks
>           3 large files
> 
>       15803 regular files
>        3318 directories
>           0 character device files
>           0 block device files
>           0 fifos
>           0 links
>          14 symbolic links (14 fast symbolic links)
>           0 sockets
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
