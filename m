From: Ron Johnson <ron.l.johnson@cox.net>
Subject: ioctl32 (was Re: filefrag abort)
Date: Tue, 21 Jul 2009 19:33:03 -0500
Message-ID: <4A665E3F.7000109@cox.net>
References: <4A64E650.6020603@cox.net> <20090721020312.GL2416@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmmtao107.cox.net ([68.230.240.59]:63055 "EHLO
	eastrmmtao107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZGVAdF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jul 2009 20:33:05 -0400
Received: from eastrmimpo01.cox.net ([68.1.16.119])
          by eastrmmtao107.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20090722003304.QVU4885.eastrmmtao107.cox.net@eastrmimpo01.cox.net>
          for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 20:33:04 -0400
In-Reply-To: <20090721020312.GL2416@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-07-20 21:03, Theodore Tso wrote:
> On Mon, Jul 20, 2009 at 04:49:04PM -0500, Ron Johnson wrote:
>> Hi,
>>
>> (Is this OT?  http://sourceforge.net/forum/forum.php?forum_id=7052  
>> doesn't show much activity...)
>>
>> Debian Sid, e2fsprogs 1.41.8-1
>> Home-rolled 64-bit 2.6.30 with 32-bit userland
> 
> Should be fixed in e2fsprogs 1.41.8-2

ff seems to work now, but I still get this in dmesg:

[188883.274547] ioctl32(filefrag:7086): Unknown cmd fd(3) 
cmd(c020660b){t:'f';sz:32} arg(ffacb808) on /some/large/file

-- 
Scooty Puff, Sr
The Doom-Bringer
