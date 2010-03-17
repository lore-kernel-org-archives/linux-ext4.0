From: "Wei, Zibiao" <zwei@syncsort.com>
Subject: Meta BGs and Flex BGs
Date: Wed, 17 Mar 2010 09:50:56 -0400
Message-ID: <1E6F625B713B6F429425AD4B5A8034A96811B5@email4.us.syncsort.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from email4.syncsort.com ([65.115.38.4]:9705 "EHLO
	email4.us.syncsort.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab0CQNu6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Mar 2010 09:50:58 -0400
Content-Class: urn:content-classes:message
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Can both EXT4_FEATURE_INCOMPAT_META_BG and EXT4_FEATURE_INCOMPAT_FLEX_BG
flags turn on the same time? If yes, I am wondering whether there is a
correlation between the numbers of block groups in META group and FLEX
group. Where are backups of superblock and group description table (GDT)
stored in this case?



Thanks.


_____________________________________________________________________________

ATTENTION:

The information contained in this message (including any files transmitted 
with this message) may contain proprietary, trade secret or other 
confidential and/or legally privileged information. Any pricing 
information contained in this message or in any files transmitted with 
this message is always confidential and cannot be shared with any third 
parties without prior written approval from Syncsort. This message is 
intended to be read only by the individual or entity to whom it is 
addressed or by their designee. If the reader of this message is not the 
intended recipient, you are on notice that any use, disclosure, copying or 
distribution of this message, in any form, is strictly prohibited. If you 
have received this message in error, please immediately notify the sender 
and/or Syncsort and destroy all copies of this message in your possession, 
custody or control.
