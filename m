From: Tao Ma <tao.ma@oracle.com>
Subject: fiemap is broken for sparse file in ext4?
Date: Fri, 11 Jun 2010 10:15:10 +0800
Message-ID: <4C119C2E.2090801@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:29400 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760036Ab0FKCQu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jun 2010 22:16:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted and other ext4 gurus,
	I found fiemap may be broken for sparse files in ext4. Here is a simple 
example.

dd if=/dev/zero of=testfile1 bs=1M count=1
using fiemap shows that it has a delalloc extent.
Logical: 0 Ext length: 1048576	Physical: 0	flags: 7

flags 7 means FIEMAP_EXTENT_LAST, FIEMAP_EXTENT_UNKNOWN and 
FIEMAP_EXTENT_DELALLOC,

while if we create a sparse file, fiemap will not show the delalloc extent.
dd if=/dev/zero of=testfile1 bs=1M count=1 seek=1
using fiemap shows that it has no extent for the file. while we should 
have some output like:
Logical: 1048576 Ext length: 1048576	Physical: 0	flags: 7

So we have different output with sparse and non-sparse file. Is it a bug 
for ext4?

Regards,
Tao
