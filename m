From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Status of META_BG?
Date: Thu, 15 Mar 2012 10:25:28 -0600
Message-ID: <20D13AAA-070A-4EE4-AC97-B553DC916228@dilger.ca>
References: <4F620EDA.8030701@ubuntu.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:62839 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031673Ab2COQZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Mar 2012 12:25:03 -0400
In-Reply-To: <4F620EDA.8030701@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-15, at 9:46 AM, Phillip Susi wrote:
> What is the status of the META_BG feature?  I thought that it never got off the ground, and FLEX_BG was used instead.  Is there still a possibility of META_BG being implemented in the future, or is the code for it currently in e2fsprogs cruft?

META_BG serves a different purpose than FLEX_BG, but you are right that
it never really got off the ground.

META_BG is needed to overcome the problem of the backup group descriptor
blocks growing to become too large, and to simplify the task of online
(or offline) filesystem resizing.

In the case of very large filesystems (256TB or more, assuming 4kB
block size) the group descriptor blocks will grow to fill an entire
block group, and in the case of group 0 and group 1 they would start
overlapping, which would not work.

For filesystem resizing, if the number of group descriptor blocks
grows, and there is not a reserved block for it, then the online
resize would fail, and the offline resize needs to move data and/or
metadata in order to make the group descriptor blocks sequential.

META_BG addresses both of these issues by distributing the group
descriptor blocks into the filesystem for each "meta group" (= the
number of groups whose descriptors fit into a single block).

The number of backups is reduced (0 - 3 backups), and the blocks do
not need to be contiguous anymore.

So, there is still value in making this feature work, but it hasn't
been high on anyone's list yet.  Assistance welcome.

Cheers, Andreas





