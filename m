From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Patch queue update
Date: Thu, 24 Jan 2008 10:32:17 -0600
Message-ID: <4798BD91.20108@redhat.com>
References: <20080124145051.GC14348@skywalker> <20080124162656.GJ18433@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYAXQcr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2008 11:32:47 -0500
In-Reply-To: <20080124162656.GJ18433@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jan 24, 2008  20:20 +0530, Aneesh Kumar K.V wrote:
>> @@ -89,6 +89,8 @@ When mounting an ext4 filesystem, the following option are accepted:
>>  extents			ext4 will use extents to address file data.  The
>>  			file system will no longer be mountable by ext3.
>>  
>> +noextents		ext4 will not use extents for new files created.
>> +
> 
> s/new files created/newly created files/

Would a blurb about keeping ext3 disk-format compatibility be worthwhile
here?

>>  journal_checksum	Enable checksumming of the journal transactions.
>>  			This will allow the recovery code in e2fsck and the
>>  			kernel to detect corruption in the kernel.  It is a
>> @@ -206,6 +208,10 @@ nobh			(a) cache disk block mapping information
>>  			"nobh" option tries to avoid associating buffer
>>  			heads (supported only for "writeback" mode).
>>  
>> +mballoc		(*)	Use the mutliblock allocator for block allocation

speeeeling on "mutliblock" too :)

-Eric
