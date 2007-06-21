From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 11/11][take 2] 48-bit block number for ACL in e2fsprogs
Date: Thu, 21 Jun 2007 16:44:28 -0600
Message-ID: <20070621224428.GE5181@schatzie.adilger.int>
References: <467A9E02.5030701@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:58917 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXFUWob (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 18:44:31 -0400
Content-Disposition: inline
In-Reply-To: <467A9E02.5030701@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 21, 2007  17:49 +0200, Valerie Clement wrote:
> This patch is intended to contain the changes to support 48-bit block
> numbers for ACL. For now, it only contains modifications in the inode
> structure. It has to be completed.
>=20
> Andreas proposed to rename i_file_acl to i_file_ea
> and i_file_acl_high to i_file_ea_hi.

Yes, it is misleading that these are called "ACL", since the ACL is onl=
y
optionally stored internal to the EA block.  We should provide compatib=
ility
macros to avoid breaking old code, which will also allow incremental
migration.

> @@ -449,6 +450,7 @@ struct ext2_inode_large {
>  #define i_reserved1	osd1.masix1.m_i_reserved1
>  #define i_frag		osd2.masix2.m_i_frag
>  #define i_fsize		osd2.masix2.m_i_fsize
> +#define i_file_acl_high	osd2.masix2.m_i_file_acl_high
>  #define i_reserved2	osd2.masix2.m_i_reserved2

On an unrelated note - does MASIX even exist anymore?  I think it was o=
nly
a very experimental OS that R=E9my Card worked on, and the home page do=
esn't
even exist anymore.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
