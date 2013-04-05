From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH v3] xfstests: add a new test case for ext4 indirect-based
 file
Date: Fri, 5 Apr 2013 10:06:25 -0500
Message-ID: <515EE871.1060106@sgi.com>
References: <1364119002-17350-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <xfs@oss.sgi.com>, <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@sandeen.net>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:55578 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab3DEPGH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Apr 2013 11:06:07 -0400
In-Reply-To: <1364119002-17350-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Zheng,

Another nice patch that needs to be reworked so that the test resides 
in the tests/generic directory.  Don't worry about the test number, it 
will be adjusted to be the next in test group when committed.

Thanks
--Rich


