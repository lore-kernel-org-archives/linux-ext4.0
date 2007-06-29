From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Date: Fri, 29 Jun 2007 10:29:21 -0400
Message-ID: <46851741.3030707@garzik.org>
References: <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070628025543.9467216f.akpm@linux-foundation.org> <20070628175757.GA1674@amitarora.in.ibm.com> <20070628113342.c9c0f49c.akpm@linux-foundation.org> <20070629135612.GH29279@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>,
	Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com,
	cmm@us.ibm.com, xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070629135612.GH29279@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> I don't think we have a problem here.  What we have now is fine, and

It's fine for ext4, but not the wider world.  This is a common problem 
created by parallel development when code dependencies exist.


> In any case, the plan is to push all of the core bits into Linus tree
> for 2.6.22 once it opens up, which should be Real Soon Now, it looks
> like.

Presumably you mean 2.6.23.

	Jeff



