From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 Size Restrictions
Date: Mon, 09 Jun 2014 13:11:34 -0500
Message-ID: <5395F8D6.6010409@redhat.com>
References: <CAF8aoe0Ho8GozZ_jTk90n9jbVqcBaVzr3-P6twbsfAs2jNKYDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Mahesh Khanwalkar <maheshkhanwalkar@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbaFISLg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jun 2014 14:11:36 -0400
In-Reply-To: <CAF8aoe0Ho8GozZ_jTk90n9jbVqcBaVzr3-P6twbsfAs2jNKYDw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/9/14, 1:03 PM, Mahesh Khanwalkar wrote:
> Hello,
> Ext4 supports max file size of 16TiB and max volume of 1EiB. What
> exactly in the implementation causes this restriction? Also is there
> any plans (as of now) to make it max sizes larger?

The ext4 extent format on disk is:

struct ext4_extent {
        __le32  ee_block;       /* first logical block extent covers */
        __le16  ee_len;         /* number of blocks covered by extent */
        __le16  ee_start_hi;    /* high 16 bits of physical block */
        __le32  ee_start_lo;    /* low 32 bits of physical block */
};

The file size is limited by a 32-bit number for the starting logical block
of an extent, ee_block.

2^32 * 4k blocks gives 16TiB

The 48 bits for physical start high/low gives you the 1 EiB (2^48*4096).

I don't know of any plans to make either of these larger.  Surely 1EiB
suffices for now.  16TiB, perhaps not so much.

-Eric

> Thanks,
> Mahesh Khanwalkar

