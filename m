Return-Path: <SRS0=0MVU=MR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40712 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbeJEHzy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Oct 2018 03:55:54 -0400
Subject: [PATCH 0/2] ext4: even more documentation fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org,
        corbet@lwn.net
Date: Thu, 04 Oct 2018 17:59:31 -0700
Message-ID: <153870117116.30837.1220267868954289184.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This series fixes some problems that were brought up during review for
the XFS documentation which I hadn't known about when pushing the ext4
documentation during the 4.19 cycle.

The first patch moves the ext4 mount option and sysfs knob information
into the Linux administration guide.

The second patch moves the ext4 Data Structures & Algorithms book up a
level since it's a self-contained documentation book.

I've built the docs and put them here, in case you hate reading rst:
https://djwong.org/docs/kdoc/filesystems/ext4/index.html

The patchset should apply cleanly against 4.19-rc6.  Comments and
questions are, as always, welcome.

--D
