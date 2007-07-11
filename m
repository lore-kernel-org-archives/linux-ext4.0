From: Dave Jones <davej@redhat.com>
Subject: Re: [EXT4 set 1][PATCH 2/2] Enable extents by default for ext4dev
Date: Tue, 10 Jul 2007 23:35:53 -0400
Message-ID: <20070711033553.GA27564@redhat.com>
References: <1183275361.4010.119.camel@localhost.localdomain> <20070710163015.ab40ed2a.akpm@linux-foundation.org> <1184103313.3759.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1184103313.3759.44.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 10, 2007 at 05:35:13PM -0400, Mingming Cao wrote:
 > 
 > Sorry about this. I was using version 0.04. The latest one I can find
 > for now is 0.05(searching lkml), but it didn't catch this codling style
 > bug either. I appreciate if anyone can point me the version 0.07, thanks

It's now in-tree in scripts/checkpatch.pl
(linus' tree is still at 0.06 though, I suspect Andrew has something
 newer in -mm)

	Dave

-- 
http://www.codemonkey.org.uk
