From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: ext4 compat flag assignments
Date: Fri, 06 Oct 2006 15:33:53 +0200
Message-ID: <45265B41.6090006@bull.net>
References: <20060922091520.GC6335@schatzie.adilger.int> <20060928085515.GC27104@openx1.frec.bull.fr> <20061004200440.GB1656@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:3523 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1422689AbWJFNfN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Oct 2006 09:35:13 -0400
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20061004200440.GB1656@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Thu, Sep 28, 2006 at 10:55:15AM +0200, Alexandre Ratchov wrote:
>> struct ext4_super_block
>> {
>> 	/* at offset 0xfe */
>> 	__le32	s_desc_size;		/* Group descriptor size */
>> 	/* at offset 0x150 */
>> 	__le32	s_blocks_count_hi;	/* Blocks count */
>> 	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
>> 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
>> 	__le32	s_jnl_blocks_hi[17];	/* Backup of the journal inode */
>> };
>=20
> Why do we need to have the high blocks # of the journal inode.
> s_jnl_blocks was just a backup of the i_blocks[] array.  But if we ar=
e
> assuming that we will only support 64-bits using extents, we shouldn'=
t
> need s_jnl_blocks_hi[].  How specifically is this array being used in
> the patches?

The s_jnl_blocks_hi[] array is not used in the current patchset.
Alexandre wanted to reserve these fields for a future use, for instance=
=20
to support larger inode sizes.
As we'll not use them in the short term and we'll still need to think=20
about that, you can remove this array.

Regards,
   Val=E9rie

-
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
