From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfstest: fsstress should kill children tasks before
 exit
Date: Thu, 6 Oct 2011 15:51:09 -0400
Message-ID: <20111006195109.GH13434@infradead.org>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
 <1317820838.2226.11.camel@doink>
 <87zkhf369y.fsf@dmbot.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aelder@sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87zkhf369y.fsf@dmbot.sw.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 05, 2011 at 05:41:13PM +0400, Dmitry Monakhov wrote:
> Ok i'll resend patch shortly, Actually test_case was explained inside
> description. So far i've able to caught 3 different minor
> fs-corruptions, one BUG_ON on ext4. And when i've run this test
> on host with 24-cores it deadlock inside dcache core. 

Having the test in the commit message doesn't really help with running
it as part of a regression test suite :)

Please report the details on the dcache deadlock to linux-fsdevel.

