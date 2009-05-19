From: Alex Tomas <bzzz@sun.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Tue, 19 May 2009 16:01:36 +0400
Message-ID: <4A129FA0.9050500@sun.com>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu>
 <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan>
 <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan>
 <20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan>
 <20090514212325.GG21316@mit.edu> <m2iqjx5s4n.fsf@vador.mandriva.com>
 <20090519113644.GA7927@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Thierry Vignaud <tvignaud@mandriva.com>,
	Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:58097 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZESMC1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 08:02:27 -0400
Received: from fe-emea-10.sun.com (gmp-eb-lb-1-fe3.eu.sun.com [192.18.6.10])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n4JC2K2g016272
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2009 12:02:23 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KJW002000RPWX00@fe-emea-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 19 May 2009 13:02:20 +0100 (BST)
In-reply-to: <20090519113644.GA7927@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On the other hand, most of the time writes into the directory will
> tend to be into pre-existing free space; but if you had two parallel
> cp's copying a large number of files into the same directory, that
> could certainly happen.

isn't access to a directory protected with i_mutex ?

thanks, Alex

