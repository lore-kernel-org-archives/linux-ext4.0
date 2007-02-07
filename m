From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Testing ext4 persistent preallocation patches for 64 bit features
Date: Wed, 7 Feb 2007 13:18:01 +0530
Message-ID: <20070207074801.GA5419@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070117094658.GA17390@amitarora.in.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I plan to test the persistent preallocation patches on a huge sparse
device, to know if >32 bit physical block numbers (upto 48bit) behave as
expected. I have following questions for this and will appreciate
suggestions here:

a) What should be the sparse device size which I should use for testing?
Should a size of > 8TB (say, 100 TB) be enough ?
The physical device (backing store device) size I can have is upto 70GB.

b) How do I test allocation of >32 bit physical block numbers ? I can
not fill > 8TB, since the physical storage available with me is just
70GB.

c) Do I need to put some hack in the filesystem code for above (to
allocate >32 bit physical block numbers) ?

Any further ideas on how to test this will help. Thanks!

--
Regards,
Amit Arora
