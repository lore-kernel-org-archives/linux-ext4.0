From: Jean noel Cordenner <jean-noel.cordenner@bull.net>
Subject: Re: [PATCH 0/6] inode version updated patches
Date: Fri, 15 Jun 2007 16:28:49 +0200
Message-ID: <4672A221.2050002@bull.net>
References: <1181836571.7779.42.camel@garfield> <1181854139.3883.7.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43737 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbXFOOeq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jun 2007 10:34:46 -0400
In-Reply-To: <1181854139.3883.7.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mingming Cao a =E9crit :
> On Thu, 2007-06-14 at 21:26 +0530, Kalpak Shah wrote:
>> Hi,
>>
>> I have updated the inode version patches and below are the details:
>>
>> 64-bit-i_version.patch which only replaces the 32-bit i_version fiel=
d in
>> the generic inode with a 64-bit i_version field. The VFS-level updat=
es
>> of the inode version are still in the i_version_update_vfs.patch and
>> this patch has been moved to the bottom of the patch series.
>>
>> ext4_i_version_hi_2.patch was still using ei->i_fs_version instead o=
f
>> inode->i_version. I have corrected this patch.
>>
>> Also there were whitespace problems in i_version_hi.patch.
>>
>> I am also attaching a ext4_no_version.patch which adds a "noversion"
>> mount option to disable inode version updates.
>>
>> I am not sure why i_version needs to be updated in VFS since it is b=
eing
>> updated in ext4_mark_iloc_dirty().
>>
>=20
> Yes I think we can remove the inode version update in VFS patch. So I=
 am
> going to drop the patch 5/6.  Jean Noel, if you disagree, please let =
me
> know.
>=20

I agree, the update of the i_version in the vfs are done in
simple_rename() , simple_link() , simple_unlink() , which are mainly=20
used by fs/ramfs and fs/hugetlbfs. So I think if each fs can update the=
=20
i_version, that will be good.

Jean noel
