From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc fragmenting files?
Date: Fri, 26 Oct 2007 22:08:47 -0500
Message-ID: <4722ABBF.1030503@redhat.com>
References: <47225B1E.2060708@redhat.com> <20071026221938.GV3042@webber.adilger.int> <4722A87F.3070709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex.tomas@sun.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbXJ0DIt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Oct 2007 23:08:49 -0400
In-Reply-To: <4722A87F.3070709@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:

> but not yet O_DIRECT, will do.


dd if=/dev/zero oflag=direct of=/mnt/test/foobar bs=1024k count=8192

filefrag -v /mnt/test/foobar  | grep -i extents
File is stored in extents format
/mnt/test/foobar: 67 extents found


http://people.redhat.com/esandeen/seekwatcher/ext4-dd-write-odirect.png

-Eric
