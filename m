From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH v5] ext4: make quota as first class supported feature
Date: Wed, 11 Jan 2012 11:13:52 -0800
Message-ID: <CAGr1F2EdAb38UOnMLJ66E3X+GWb8mCMW3RABHWoib53duma8kQ@mail.gmail.com>
References: <1326309116-28723-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: adilger@dilger.ca, tytso@mit.edu, dmonakhov@openvz.org,
	jack@suse.cz, johann@whamcloud.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54713 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2AKTON (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jan 2012 14:14:13 -0500
Received: by dajs34 with SMTP id s34so604398daj.19
        for <linux-ext4@vger.kernel.org>; Wed, 11 Jan 2012 11:14:13 -0800 (PST)
In-Reply-To: <1326309116-28723-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Changes since v4:
- Handle error when we fail to enable quotas after a remount.

Changes since v3:- Fail mount if unable to load quotas at mount time-
Add ext4_quota_off_sysfile (quota-off function to be used when
quotainodes are hidden)- Remove quota inode numbers from struct
ext4_sb_info and use themdirectly from sbi->s_es.- Enable quotas on ro
-> rw remount.
