From: Eric Sandeen <sandeen@redhat.com>
Subject: barriers off by default?
Date: Mon, 12 May 2008 10:56:21 -0500
Message-ID: <482868A5.1000102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbYELP43 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 11:56:29 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4CFuNDp011858
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 11:56:28 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CFuNbM030648
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 11:56:23 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CFuLu3010070
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 11:56:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As I look at my shiny new 500G disks with 32MB of cache, I find myself
wondering why the default for ext3 and ext4 is to have barriers disabled.

This is a pretty dangerous default w.r.t. filesystem integrity on power
loss, no?

Thanks,

-Eric
