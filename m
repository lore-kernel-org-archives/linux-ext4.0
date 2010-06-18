From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fio test triggering bad data on ext4
Date: Fri, 18 Jun 2010 09:02:27 -0500
Message-ID: <4C1B7C73.505@redhat.com>
References: <4C1B292C.2080205@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364Ab0FROCe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jun 2010 10:02:34 -0400
In-Reply-To: <4C1B292C.2080205@fusionio.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jens Axboe wrote:
> Hi,
> 
> I was writing a small fio job file to do writes and read verifies on a
> device. It forks 32 processes, each writing randomly to 4 files with a
> block size between 4k and 16k. When it has written 1024 of those blocks,
> it'll verify the oldest 512 of them. Each block is checksummed for every
> 512b. It uses libaio and O_DIRECT.
> 
> It works on ext2 and btrfs. I haven't run it to completion yet, but they
> survive 15-20 minutes just fine. ext4 doesn't even go a full minutes
> before this triggers:

Jens, can you try XFS too?  Since ext3 can't do direct IO to a hole,
(and I'm not sure about btrfs in that regard), ext4 may be most similar
to xfs's behavior on the test ... wondering how it fares.

Thanks,
-Eric

