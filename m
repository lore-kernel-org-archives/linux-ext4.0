Return-Path: <SRS0=0MVU=MR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38772 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbeJEJpU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Oct 2018 05:45:20 -0400
Subject: Re: [PATCH 0/2] ext4: even more documentation fixes
To: "Darrick J. Wong" <darrick.wong@oracle.com>, tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org,
        corbet@lwn.net
References: <153870117116.30837.1220267868954289184.stgit@magnolia>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <007a23b2-1db3-36fb-3300-f94115d4f2b3@infradead.org>
Date: Thu, 4 Oct 2018 19:48:31 -0700
MIME-Version: 1.0
In-Reply-To: <153870117116.30837.1220267868954289184.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/4/18 5:59 PM, Darrick J. Wong wrote:
> Hi all,
> 
> This series fixes some problems that were brought up during review for
> the XFS documentation which I hadn't known about when pushing the ext4
> documentation during the 4.19 cycle.
> 
> The first patch moves the ext4 mount option and sysfs knob information
> into the Linux administration guide.
> 
> The second patch moves the ext4 Data Structures & Algorithms book up a
> level since it's a self-contained documentation book.
> 
> I've built the docs and put them here, in case you hate reading rst:
> https://djwong.org/docs/kdoc/filesystems/ext4/index.html
> 
> The patchset should apply cleanly against 4.19-rc6.  Comments and
> questions are, as always, welcome.

Hi Darrick,

I don't see patch 2/2 anywhere (my inbox, email archives)...

-- 
~Randy
