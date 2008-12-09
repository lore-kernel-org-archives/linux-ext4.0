From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Checking link targets are NULL-terminated
Date: Tue, 09 Dec 2008 20:00:12 +0200
Message-ID: <493EB22C.2050108@panasas.com>
References: <20081205144810.GA25585@dastardly.home.dghda.com> <20081208143003.9449bc77.akpm@linux-foundation.org> <20081209171814.GA8667@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Duane Griffin <duaneg@dghda.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081209171814.GA8667@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Dec 08, 2008 at 02:30:03PM -0800, Andrew Morton wrote:
>> Perhaps nd_set_link() is a suitable place?  Change that function so
>> that it is passed a third argument (max_len) and then check that within
>> nd_set_link().  Change nd_set_link() to return a __must_check-marked
>> errno, change callers to handle errors appropriately.
>>
>> Or something totally different ;)  But along those lines?
> 
> Note that XFS and possibly other filesystem don't store the NULL
> termination on disk.  

Note that ext2, for example, also only writes the string bytes without
any NULLs. It only happen to be zero padded because any last-page is zero-padded
from i_size to end of page.

> So having a follow_link interface that uses a
> counted string would be a nice little optimization for the XFS
> follow_link / readlink implementation.   But I'm not really sure it's
> worth complicating the VFS for that little gem.
> 

The inode's i_size already holds the string count so at the higher level
we have that information. But I'm convinced, nd_set_link() should receive
a new max_len, all users should be changed as a matter of code audit.
nd_set_link() should then proceed to truncate the string at that length
unconditionally no need for error returns.

My $0.017
Boaz
