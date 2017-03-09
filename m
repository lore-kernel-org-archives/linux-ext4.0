From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] generic: require journal in shutdown tests
Date: Thu, 9 Mar 2017 00:54:34 -0500
Message-ID: <20170309055434.ufeyr2u2vl6p7bzv@thunk.org>
References: <20170307061609.27099-1-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170307061609.27099-1-eguan@redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 07, 2017 at 02:16:09PM +0800, Eryu Guan wrote:
> Tests in shutdown group are supposed to test journal recovery after
> filesystem shutdown, and the tests assume the filesystem in test has
> journal support. But with the ext4 shutdown function added in
> 4.11-rc kernel, ext2 gains shutdown support too when driving with
> ext4 driver, so generic/051 fails because fs corruption after test.
> 
> Adding _require_metadata_journaling to all generic tests in shutdown
> group to ensure there's journal present.
> 
> generic/050 is skipped because it has _require_scratch_nocheck,
> which indicates no fsck is done after test.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

Thanks!!

					- Ted
