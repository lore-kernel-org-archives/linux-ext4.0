From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/13] dax, iomap: Add support for synchronous faults
Date: Thu, 24 Aug 2017 05:27:20 -0700
Message-ID: <20170824122720.GA9961@infradead.org>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-12-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Boaz Harrosh <boazh@netapp.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-12-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Just curious:  how does IOMAP_F_NEEDDSYNC practically differ
from IOMAP_F_NEW?
