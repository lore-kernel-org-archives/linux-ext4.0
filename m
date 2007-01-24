From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC] [patch 0/3] i_version update for ext4
Date: Wed, 24 Jan 2007 09:40:34 -0800
Message-ID: <45B79A12.4060004@us.ibm.com>
References: <45B644AA.1070409@bull.net> <20070123184611.GF5236@schatzie.adilger.int> <45B76961.7030509@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
To: Cordenner jean noel <jean-noel.cordenner@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37086 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbXAXQor (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jan 2007 11:44:47 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0OGikxx003011
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jan 2007 11:44:46 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0OGiXdN191958
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jan 2007 11:44:33 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0OGiX0M017569
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jan 2007 11:44:33 -0500
In-Reply-To: <45B76961.7030509@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Cordenner jean noel wrote:
> Andreas Dilger a =E9crit :
>=20
>> On Jan 23, 2007  18:23 +0100, Cordenner jean noel wrote:
>>
>>> I've updated what was previously the change attribute patch for ext=
4
>>> initially posted by Alexandre Ratchov. The previous patch was
>>> introducing a change_attribute field, now it uses the i_version fie=
ld of
>>> the inode.
>>>
>>> The i_version field is a counter that is set on every inode creatio=
n and
>>> that is incremented every time the inode data is modified (similarl=
y to
>>> the "ctime" time-stamp).
>>> The aim is to fulfill NFSv4 requirements for rfc3530.
>>> For the moent, the counter is only a 32bit value but it is planned =
to be
>>> 64bit as required.
>>>
>>> The patch is divided into 3 parts, the vfs layer, the ext4 specific=
 code
>>> and an user part to check i_version changes via stat.
>>
>>
>> Have you had a chance to look at the performance impact of this chan=
ge
>> (possible with oprofile)?  Always marking the inodes dirty for ext3
>> may have some noticable overhead.
>>
>=20
> I did some tests using fileop with the previous version of the patch
> which was very similar. I was surprised that there was no noticable
> overhead:
>  http://www.bullopensource.org/ext4/change_attribute/index.html
>=20
> I will use oprofile to check it again.

Could we just increment the counter each time the mtime is modifies(not=
=20
the ctime)? Is that enough to serve NFSv4 need?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
