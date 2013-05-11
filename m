From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] jbd2: Fix block tag checksum verification brokenness
Date: Fri, 10 May 2013 23:18:18 -0600
Message-ID: <4CE338D9-F69A-4568-AA82-012FEED2E252@dilger.ca>
References: <20130510233807.GB5706@blackbox.djwong.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130510233807.GB5706@blackbox.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2013-05-10, at 17:38, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
> {
> 
> +    tag->t_checksum = cpu_to_be16(csum32);
> }

It wouldn't be a terrible idea to add a comment in these spots, since
it is a bit non-obvious to use cpu_to_be16() on a 32-bit variable. 

Cheers, Andreas
