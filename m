From: Andreas Dilger <adilger@sun.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Mon, 22 Jun 2009 23:13:27 +0200
Message-ID: <20090622211327.GI13398@webber.adilger.int>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com>
 <20090617234604.GF7867@mit.edu>
 <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:47655 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZFVVNf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jun 2009 17:13:35 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n5MLDXGF019736
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 14:13:35 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KLN00100S8JS500@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 22 Jun 2009 14:13:33 -0700 (PDT)
In-reply-to: <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 22, 2009  09:42 -0700, Curt Wohlgemuth wrote:
> I tested the locale-gen example with all combinations of
> 
>    data=writeback
>    data=ordered
>    data=journal
>    <no journal at all>

On an unrelated note - would it be useful to mount an ext4 filesystem
with a journal using "data=none" (or similar) to run without a journal?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

