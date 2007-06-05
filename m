From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Patch to support LUKS UUIDs in libblkid
Date: Tue, 05 Jun 2007 09:20:23 -0500
Message-ID: <46657127.1050608@redhat.com>
References: <4665479E.2060707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Karsten Hopp <karsten@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764423AbXFEOUb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jun 2007 10:20:31 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l55EKQk7021754
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 10:20:26 -0400
In-Reply-To: <4665479E.2060707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Karsten Hopp wrote:
> Hello,
> 
> I've already posted this at the e2fsprogs sourceforge site, but our 
> e2fsprogs maintainer
> suggested that I should post it here as well for a review:
> 
> 
> Attached is a patch to add cryptsetup-luks UUID detection in libblkid.so
> This is required when we want to use UUIDs instead of hardcoded device 
> names for
> encrypted partitions.

Hi Karsten, in the patch you posted, need to remove the 
__BLKID_ATTR((unused)) from:

+static int probe_luks(struct blkid_probe *probe,
+		       struct blkid_magic *id __BLKID_ATTR((unused)),
+		       unsigned char *buf)
+{

since id is being used now.

-Eric
