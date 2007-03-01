From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 1 Mar 2007 23:51:01 +0000
Message-ID: <20070301235101.GA2519@infradead.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <45E761CB.2020904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45E761CB.2020904@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 01, 2007 at 05:29:15PM -0600, Eric Sandeen wrote:
> Amit K. Arora wrote:
> 
> Might want more error checking in there, something like (rough cut)...
> (or is some of this glibc's job?)

Yeah, we need to have this checks.  We can't rely on userspace not
passing arguments that might corrupt your filesystem or let you
escalate privilegues.

> which would keep things in line with posix_fallocate's specified errors, 
> too?

Yes, very good idea.

