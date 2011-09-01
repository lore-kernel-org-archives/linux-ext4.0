From: "Bob Pearson" <rpearson@systemfabricworks.com>
Subject: RE: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Date: Thu, 1 Sep 2011 00:40:08 -0500
Message-ID: <03ac01cc6869$9cd23b60$d676b220$@systemfabricworks.com>
References: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com> <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: "'linux-kernel'" <linux-kernel@vger.kernel.org>,
	"'Mingming Cao'" <cmm@us.ibm.com>,
	"'linux-crypto'" <linux-crypto@vger.kernel.org>,
	"'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>
To: "'Darrick J. Wong'" <djwong@us.ibm.com>,
	"'Andreas Dilger'" <adilger.kernel@dilger.ca>,
	"'Herbert Xu'" <herbert@gondor.apana.org.au>,
	"'Theodore Tso'" <tytso@mit.edu>,
	"'David Miller
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:34311 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286Ab1IAFkL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Sep 2011 01:40:11 -0400
In-Reply-To: <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com>
Content-Language: en-us
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Darrick,

The same code in crc32.c was helpful to measure performance and help code tuning as well as indicate correctness. Otherwise the code in crypto may be enough to test all the corner cases. If this survives the review I wonder if there is a way to combine crc32 and crc32c together somehow. I like yours because you can load/unload and not need the memory permanently.

Bob

