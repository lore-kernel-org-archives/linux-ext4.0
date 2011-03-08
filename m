From: Amir Goldstein <amir73il@gmail.com>
Subject: [LSF/FS TOPIC] Journal guided RAID resync
Date: Tue, 8 Mar 2011 17:35:36 +0200
Message-ID: <AANLkTik72=3h4T=MNnaqLFdfYHraYp8T=eaNyijFiY9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: lsf-pc@lists.linuxfoundation.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi All,

I have picked up the old ext3/jbd patches a while ago and
was trying to figure out how difficult would it be to port them
to ext4/jbd2.

The gain from these patches to anyone using software RAID
should be clear, see:
http://lwn.net/Articles/363490/

What is not clear to me at this point is what are the
performance implications, if any, of withholding "declared" data
writeback until journal commit.

I also did not get to estimating the effort involved in the porting
to ext4/jbd2. The absence of ext3/jbd "dirty data" buffers list is
going to be one of the issues to deal with.

Does anyone out there have interest in pushing this forward?

Amir.
