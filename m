From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: Port xfstests 145, 161, 175, 176, 185?
Date: Thu, 09 Jun 2011 12:17:59 -0700
Message-ID: <4DF11C67.8090702@linux.vnet.ibm.com>
References: <4DEFC41A.9070701@linux.vnet.ibm.com> <20110609110826.GA14899@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42845 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab1FITSD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jun 2011 15:18:03 -0400
In-Reply-To: <20110609110826.GA14899@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/09/2011 04:08 AM, Christoph Hellwig wrote:
> On Wed, Jun 08, 2011 at 11:48:58AM -0700, Allison Henderson wrote:
>> During one of my reviews for the punch hole tests patch set it was
>> mentioned that it would be helpful to take the xfstests 145, 161,
>> 175, 176, 185 and modify them such that they can run with out
>> requiring the dmapi.  These tests contain some more interesting
>> punch hole tests, but they dont normally run unless there is support
>> for dmapi.
>>
>> I did take a peek at them and I was thinking that if we decide to do
>> this, we would probably need to do something like introduce a new
>> set of source code that is similar to what is seen under the dmapi
>> folder, but modified to use a generic interface instead of the dmapi
>> libraries.  We could try to merge them into a single code path, but
>> I think that may introduce more complexities than would be
>> desirable.
>
> Most of it should be doable using xfs_io.  If it's nessecary to write
> new source files because of e.g. concurrency tests that we can't easily
> do from xfs_io please add new source files to the src/ directory.
>
> Also, please don't rewrite the actual existing dmapi test cases, but
> add new ones testing these patterns using the fallocate interface, as
> the coverage for the dmapi interface still is useful.
>

Alrighty, thx Christoph.  I will keep this work item on my todo list then.
