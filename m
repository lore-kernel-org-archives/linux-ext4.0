From: Nathan Scott <nscott@aconex.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Date: Fri, 29 Jun 2007 09:39:40 +1000
Message-ID: <1183073980.15488.134.camel@edge.yarra.acx>
References: <20070614091458.GH5181@schatzie.adilger.int>
	 <20070614120413.GD86004887@sgi.com>
	 <20070614193347.GN5181@schatzie.adilger.int>
	 <20070625132810.GA1951@amitarora.in.ibm.com>
	 <20070625134500.GE1951@amitarora.in.ibm.com>
	 <20070625150320.GA8686@amitarora.in.ibm.com>
	 <20070625214626.GJ5181@schatzie.adilger.int>
	 <20070626103247.GA19870@amitarora.in.ibm.com>
	 <20070626153413.GC6652@schatzie.adilger.int>
	 <20070626231803.GQ31489@sgi.com>
	 <20070628181913.GC1674@amitarora.in.ibm.com>
Reply-To: nscott@aconex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070628181913.GC1674@amitarora.in.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-06-28 at 23:49 +0530, Amit K. Arora wrote:
> 
> > Correct, but for swap files that's not an issue - no user should be
> able
> > too read them, and FA_MKSWAP would really need root privileges to
> execute.
> 
> Will the FA_MKSWAP mode still be required with your suggested change
> of
> teaching do_mpage_readpage() about unwritten extents being in place ?
> Or, will you still like to have FA_MKSWAP mode ? 

There's no need for a MKSWAP flag.

cheers.

--
Nathan

