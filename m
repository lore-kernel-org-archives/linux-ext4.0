From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: Re: [RFC] [patch 2/3] i_version update for ext4: ext4 specific code
Date: Wed, 24 Jan 2007 15:07:52 +0100
Message-ID: <45B76838.4000903@bull.net>
References: <45B644C0.50503@bull.net> <20070123184814.GG5236@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57517 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXAXOIf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jan 2007 09:08:35 -0500
In-Reply-To: <20070123184814.GG5236@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger a =E9crit :
> On Jan 23, 2007  18:24 +0100, Cordenner jean noel wrote:
>> @@ -336,7 +336,7 @@
>>  #define i_size_high    i_dir_acl
>>
>>  #if defined(__KERNEL__) || defined(__linux__)
>> -#define i_reserved1    osd1.linux1.l_i_reserved1
>> +#define ext4_i_version  osd1.linux1.l_i_version
>=20
> This naming is inconsistent with other inode fields, what about
> i_disk_version, like i_disk_size also used in the code?
>=20

I agree that sounds better
