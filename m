Return-Path: <SRS0=wjg6=MI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42958 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbeI0BT7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Sep 2018 21:19:59 -0400
Subject: [PATCH 0/3] ext4: documentation fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org
Date: Wed, 26 Sep 2018 12:05:31 -0700
Message-ID: <153798873160.29896.3647029167086263735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This series fixes some problems with building the in-kernel ext4
documentation.  Specifically, it re-enables building a pdf containing
only the ext4 documentation; fixes some table column width problems; and
converts the mount option / ioctl / sysfs tunable documentation to use
indented paragraphs instead of tables.  That last change makes it easier
to maintain the rst text and uses whitespace more efficiently in the
output.

I've built the docs and put them here, in case you hate reading rst:
https://djwong.org/docs/kdoc/filesystems/ext4/index.html

The patchset should apply cleanly against 4.19-rc5.  Comments and
questions are, as always, welcome.

--D
