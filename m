From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH v2] ext4: add checks of block references for non-extent
 inodes
Date: Tue, 31 Mar 2009 14:50:38 +0200
Message-ID: <49D2119E.2050309@ph.tum.de>
References: <49B94396.2020800@ph.tum.de> <49C3A51C.1030201@ph.tum.de> <49D1D737.9080105@ph.tum.de> <20090331123755.GE13356@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:52779 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756815AbZCaMuk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Mar 2009 08:50:40 -0400
In-Reply-To: <20090331123755.GE13356@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Mar 31, 2009 at 10:41:27AM +0200, Thiemo Nagel wrote:
>> Dear Ted, Aneesh, Stephen,
>>
>> thanks a lot for your comments and fixes!  The attached patch (applied  
>> on-top) should fix the
>> * buffer head leak spotted by Aneesh
>> * warning reported by Stephen
> 
> Thanks, I've merged this into your patch in the ext4 patch queue.

Thank you!

BTW:  Do you want this patch also for ext2/3 ?

Kind regards,

Thiemo
