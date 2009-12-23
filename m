From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Subject: RE: About strange behaviour of ext4 allocation algorithm
Date: Wed, 23 Dec 2009 13:52:48 +0300
Message-ID: <41BA663C8B2F72499F48B0EF991C188E0478A366D3@RU-EXSTRCL1.ru.corp.acronis.com>
References: <41BA663C8B2F72499F48B0EF991C188E047890DF84@RU-EXSTRCL1.ru.corp.acronis.com>
 <E1904714-A014-422C-91BF-E39E736285CD@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from edge1.acronis.com ([91.195.23.132]:19720 "EHLO
	edge1.acronis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbZLWKxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Dec 2009 05:53:07 -0500
In-Reply-To: <E1904714-A014-422C-91BF-E39E736285CD@sun.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 

> -----Original Message-----
> From: Andreas.Dilger@sun.com [mailto:Andreas.Dilger@sun.com] On Behalf Of Andreas Dilger
> Sent: Wednesday, December 23, 2009 1:25 AM
> To: Dubeyko, Vyacheslav
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: About strange behaviour of ext4 allocation algorithm
>
> On 2009-12-22, at 03:42, Vyacheslav Dubeyko wrote:
>> I think that I found some strange behaviour in ext4 allocation 
>> algorithm. Maybe I wrong or use not actual code but such allocation 
>> policy is strange from my point of view.
>
> What kernel version are you using?  I know Ted has looked into some allocation problems, specifically related to uninitialized groups, but I don't know 
> when they were fixed.

I use kernel: 2.6.29.4-167.fc11.i686.PAE #1 SMP Wed May 27 17:28:22 EDT 2009 i686 i686 i386 GNU/Linux.

>> First of all, I has created ext4 volume of 100 Mb in size (mkfs.ext4 
>> -b 1024 -L ext4 /dev/sdb1).
>
> If you delete your file, without reformatting the filesystem, and then re-run the test, does it produce the same results?  If not, then it is likely you are 
> seeing the problem with uninitialized groups that was fixed a month or two ago.

After deletion of the file and re-run test (without reformatting the filesystem) I have slightly different extents' tree. Index block (depth of the tree = 1) has changed place and several extents has another sizes. But nature of the extents' sequence is the same.

--
Vyacheslav Dubeyko <Vyacheslav.Dubeyko@acronis.com>
Acronis
--

