From: Avantika Mathur LTC <mathur@us.ibm.com>
Subject: Ext4 devel interlock meeting minutes (Nov. 29 2006)
Date: Wed, 29 Nov 2006 11:02:11 -0800
Message-ID: <456DD933.2090304@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:41179 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S967565AbWK2TCQ
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 14:02:16 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kATJ2Fd9014127
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 14:02:15 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kATJ2EuM299230
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 12:02:14 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kATJ2DN1030548
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 12:02:13 -0700
Received: from [127.0.0.1] (IBM-DD6E2EC41B8.beaverton.ibm.com [9.47.16.74])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kATJ2CvM030405
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 12:02:12 -0700
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 11-29-06 Minutes

Attendees: Mingming Cao, Eric Sandeen, Dave Kleikamp, Jean-Pierre Dion,=
=20
Val=E9rie Cl=E9ment, Jean-Noel Cordenner, Takashi Sato, Ted Ts'o, Avant=
ika=20
Mathur

- Preallocation:
  -- Suparna is has started working on implementation and will=20
temporarily use ioctls as interface.
  -- Discussed XFS implementation details posted by Eric, why there are=
=20
two methods, one zeroing out blocks, and the other setting flag in=20
preallocated extents.
  -- Eric will work on a proposal for preallocation implementation usin=
g=20
posix_fallocate and fcntl

- Nanosecond Timestamp:
  -- Reviewed status of Patch from Andreas Dilger in June
  -- Before moving forwars, we need to address design question of=20
whether nanosecond timestamps should be supported in older filesystems=20
with 128 byte inodes.  Will this feature be backported to ext3?
  -- Ted will reopen this issue on the mailing list
  -- Current plan is to only implement finer granularity timestamps for=
=20
larger inodes, unless there is someone who feels it is critical to have=
=20
them in current inodes.

- Defragmentation Patches:
  -- Takashi is working on addine improvements including support for=20
quotas.=20
  -- Will release new patch set in early December

- e2fsprogs: No updates to e2fsprogs since last week.
  -- New WIP released week ago; includes some recent patches including=20
struct defs for new features
  -- Ted is still working to merge extents patches and will report=20
progress next week

- New Wiki: ext4.wiki.kernel.org  Still a lot of work to be done to set=
=20
it up.
  -- We will keep all interlock agendas and minutes here
  -- Will create ext4 roadmap with details on implementations for each=20
feature

- Big Block Group patches:
  -- Val=E9rie posted patches last week
  -- Need a clearer description of why this feature is needed and what=20
the benefits are
  -- Decide whether it is a necessary feature and if all large=20
filesystems should be using it.
  -- Ted will reply to Val=E9rie's patches asking about specific benefi=
ts=20
and requirements.
  -- Current thoughts on benefits of large block group size:
     o increase file system size
     o reduce file fragmentation because less extents are needed for=20
large files
     o Reduce number of block descriptors, which reduces mkfs and fsck=20
times for large filesystems
