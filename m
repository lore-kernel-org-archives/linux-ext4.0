From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc fragmenting files?
Date: Mon, 29 Oct 2007 14:13:27 -0500
Message-ID: <472630D7.4020606@redhat.com>
References: <47225B1E.2060708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbXJ2TN3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Oct 2007 15:13:29 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id l9TJDSYU018677
	for <linux-ext4@vger.kernel.org>; Mon, 29 Oct 2007 15:13:28 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9TJDSP2030719
	for <linux-ext4@vger.kernel.org>; Mon, 29 Oct 2007 15:13:28 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9TJDR9i005858
	for <linux-ext4@vger.kernel.org>; Mon, 29 Oct 2007 15:13:27 -0400
In-Reply-To: <47225B1E.2060708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:

> (note: times & rates look wrong to me, something is up with blktrace I
> think, but FIBMAP shouldn't lie about allocation)

CONFIG_NO_HZ was causing this... here are better graphs:

http://people.redhat.com/esandeen/seekwatcher/ext4-dd-write.png
http://people.redhat.com/esandeen/seekwatcher/xfs-dd-write.png
http://people.redhat.com/esandeen/seekwatcher/ext4-xfs-dd-write.png

http://people.redhat.com/esandeen/seekwatcher/ext4-dd-write-odirect.png
http://people.redhat.com/esandeen/seekwatcher/xfs-dd-write-odirect.png
http://people.redhat.com/esandeen/seekwatcher/ext4-xfs-dd-write-odirect.png

-Eric
