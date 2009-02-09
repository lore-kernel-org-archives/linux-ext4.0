From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH] Add checks to validate extent entries.
Date: Mon, 09 Feb 2009 11:40:24 +0100
Message-ID: <49900818.8010700@ph.tum.de>
References: <20090207173239.GA25942@skywalker> <1234036882-30656-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <499004C4.9040305@ph.tum.de> <20090209103158.GD31884@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:39085 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707AbZBIKkZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 05:40:25 -0500
In-Reply-To: <20090209103158.GD31884@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, Feb 09, 2009 at 11:26:12AM +0100, Thiemo Nagel wrote:
>> Aneesh Kumar K.V wrote:
>>> This patch adds check to validate the extent entries along
>>> with extent  headers. Should handle crash with corrupt filesystem.
>> While your patch probably decreases the average number of checks that
>> are done, it makes single random accesses quite expensive since always
>> complete extent blocks are checked at once, even if just a single pblock
>> is accessed.  No idea whether there are workloads which have that as a
>> typical access pattern...
> 
> The second patch make sure we do it only when we read the extent
> information from the disk.

Imagine a random read of 4k somewhere inside a very large file.  With
your patch, we will loop over several kilobytes of extent tables just
for that single read.  (The second read will be faster, of course, but
who knows whether there will be a second read?)  So I think there exist
some access patterns, for which your patch slows down things
considerably, but I cannot judge whether these are important.

Kind regards,

Thiemo

