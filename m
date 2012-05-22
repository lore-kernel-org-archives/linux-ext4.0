From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 1/2] block: add BH_Meta flag
Date: Tue, 22 May 2012 12:37:54 -0400
Message-ID: <x4962bouq71.fsf@segfault.boston.devel.redhat.com>
References: <1337257290-28547-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<patches@linaro.org>, <arnd.bergmann@linaro.org>,
	<venkat@linaro.org>, <lporzio@micron.com>, <tytso@mit.edu>,
	<adilger@dilger.ca>, <hch@infradead.org>, <bharrosh@panasas.com>,
	<deepak.saxena@linaro.org>, Saugata Das <saugata.das@linaro.org>
To: Saugata Das <saugata.das@stericsson.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1337257290-28547-1-git-send-email-saugata.das@stericsson.com>
	(Saugata Das's message of "Thu, 17 May 2012 17:51:29 +0530")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Saugata Das <saugata.das@stericsson.com> writes:

> From: Saugata Das <saugata.das@linaro.org>
>
> Today, storage devices like eMMC has special features like data tagging
> (introduced in MMC-4.5 version) in order to improve performance of some
> specific writes. On MMC stack, data tagging is used for all writes which
> has REQ_META flag set. This patch adds the capability to add REQ_META flag
> during meta data write.

Presumably you're doing this to get better performance for some
workload, yes?  Could you please let us know what workloads you tested
and how this patch set helps?  In other words, what benchmarking did you
perform and what were the results?  Do you expect this to make some
other workloads perform worse?

Cheers,
Jeff
