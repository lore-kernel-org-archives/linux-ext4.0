From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 04/13] dax: Create local variable for VMA in
 dax_iomap_pte_fault()
Date: Fri, 18 Aug 2017 16:08:00 -0600
Message-ID: <20170818220800.GC32627@linux.intel.com>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-5-jack@suse.cz>
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
In-Reply-To: <20170817160815.30466-5-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 17, 2017 at 06:08:06PM +0200, Jan Kara wrote:
> There are already two users and more are coming.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Sure.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
