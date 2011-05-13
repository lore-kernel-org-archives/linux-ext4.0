From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [TEST] test the seek_hole/seek_data functionality
Date: Fri, 13 May 2011 16:46:57 -0700
Message-ID: <4DCDC2F1.1060507@oracle.com>
References: <1304626619-1588-1-git-send-email-josef@redhat.com> <1304626619-1588-4-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	viro@ZenIV.linux.org.uk, Sunil Mushran <sunil.mushran@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:43046 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758358Ab1EMXrU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 May 2011 19:47:20 -0400
In-Reply-To: <1304626619-1588-4-git-send-email-josef@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/05/2011 01:16 PM, Josef Bacik wrote:
> This is my very rough tester for testing seek_hole/seek_data.  Please look over
> it and make sure we all agree that the semantics are correct.  My btrfs patch
> passes with this and ext3 passes as well.  I still have to added fallocate() to
> it, but for now this seems to cover most of the corner cases.  Thanks,

I am assuming that our aim is to be fully compatible with zfs.

I tried running the test on it and it failed. One reason was
that the default allocation size on zfs is 128K. The test assumes
4K. The other was our understanding of the various corner cases.
And lastly, the values for SEEK_DATA and SEEK_HOLE are 3 and 4
respectively. Not vice-versa.

So I enhanced the test a bit and have it running on zfs. If someone
else can, please do verify my results.

BTW, This test also does not touch fallocate.

http://oss.oracle.com/~smushran/seek_data/seek_test.c

On zfs:
# ./seek_test
Allocation size: 131072
01. Test basic support                                  SUCC
02. Test an empty file                                  SUCC
03. Test a full file                                    SUCC
04. Test file hole at beg, data at end                  SUCC
05. Test file data at beg, hole at end                  SUCC
06. Test file hole data hole data                       SUCC


On ext4:
# ./seek_test
Allocation size: 4096
01. Test basic support                                	SUCC
02. Test an empty file                                	SUCC
   ERROR in Test 3.4: POS expected 1, got -1
   ERROR in Test 3.6: POS expected 4195, got -1
03. Test a full file                                  	FAIL
   ERROR in Test 4.1: POS expected 0, got 8196
   ERROR in Test 4.2: POS expected 1, got 8196
   ERROR in Test 4.3: POS expected 8192, got 0
   ERROR in Test 4.4: POS expected 8192, got -1
   ERROR in Test 4.5: POS expected 8191, got 8196
   ERROR in Test 4.6: POS expected 8192, got -1
   ERROR in Test 4.8: POS expected 8192, got -1
   ERROR in Test 4.10: POS expected 8193, got -1
   ERROR in Test 4.12: POS expected 8195, got -1
04. Test file hole at beg, data at end                	FAIL
   ERROR in Test 5.1: POS expected 4096, got 16384
   ERROR in Test 5.2: POS expected 4096, got 16384
   ERROR in Test 5.4: POS expected 1, got -1
   ERROR in Test 5.5: POS expected 4096, got 16384
   ERROR in Test 5.6: POS expected 4095, got -1
   ERROR in Test 5.7: POS expected 4096, got 16384
   ERROR in Test 5.9: POS expected 4097, got 16384
   ERROR in Test 5.11: POS expected 16383, got 16384
05. Test file data at beg, hole at end                	FAIL
   ERROR in Test 6.1: POS expected 0, got 16384
   ERROR in Test 6.2: POS expected 1, got 16384
   ERROR in Test 6.3: POS expected 4096, got 0
   ERROR in Test 6.4: POS expected 4096, got -1
   ERROR in Test 6.5: POS expected 4095, got 16384
   ERROR in Test 6.6: POS expected 4096, got -1
   ERROR in Test 6.7: POS expected 8192, got 16384
   ERROR in Test 6.8: POS expected 4096, got -1
   ERROR in Test 6.9: POS expected 8192, got 16384
   ERROR in Test 6.10: POS expected 4097, got -1
   ERROR in Test 6.11: POS expected 8192, got 16384
   ERROR in Test 6.12: POS expected 8191, got -1
   ERROR in Test 6.13: POS expected 8192, got 16384
   ERROR in Test 6.14: POS expected 12288, got -1
   ERROR in Test 6.15: POS expected 8193, got 16384
   ERROR in Test 6.16: POS expected 12288, got -1
   ERROR in Test 6.17: POS expected 12287, got 16384
   ERROR in Test 6.18: POS expected 12288, got -1
   ERROR in Test 6.20: POS expected 12288, got -1
   ERROR in Test 6.22: POS expected 12289, got -1
   ERROR in Test 6.24: POS expected 16383, got -1
06. Test file hole data hole data                     	FAIL


