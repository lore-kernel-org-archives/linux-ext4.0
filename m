From: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap and
 mark_diskspace_used
Date: Tue, 25 Nov 2008 19:38:43 +0300
Message-ID: <492C2A13.3090102@sun.com>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20081123140038.GC26473@mit.edu> <492A5453.9030801@sun.com>
 <20081124113323.GC8462@skywalker>
 <1227623373.3810.7.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@MIT.EDU>, cmm@us.ibm.com,
	sandeen@redhat.com, linux-ext4@vger.kernel.org
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:42781 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYKYQjm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 11:39:42 -0500
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe2.eu.sun.com [192.18.6.11])
	by gmp-eb-inf-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAPGdd02019781
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 16:39:39 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAW00G01DPKZ300@fe-emea-09.sun.com>
 (original mail from Alex.Zhuravlev@Sun.COM) for linux-ext4@vger.kernel.org;
 Tue, 25 Nov 2008 16:39:39 +0000 (GMT)
In-reply-to: <1227623373.3810.7.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46r=E9d=E9ric Boh=E9 wrote:
> I've just tried your patch on top of the patch queue and I still have
> this error when I resize the fs while allocating blocks concurrently
> (with dd):

I believe this is because original fix is wrong. instead of uptodate we
could use different flag.

thanks, Alex

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
