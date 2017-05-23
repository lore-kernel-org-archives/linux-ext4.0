From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] ext4: Move is_32bit_api() to generic code
Date: Tue, 23 May 2017 01:36:05 -0700
Message-ID: <20170523083605.GA4107@infradead.org>
References: <1495398051-4604-1-git-send-email-richard@nod.at>
 <1495398051-4604-2-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: david@sigma-star.at, bfields@redhat.com, dedekind1@gmail.com,
 linux-kernel@vger.kernel.org, hyc.lee@gmail.com, adrian.hunter@intel.com,
 leon.pollak@gmail.com, linux-mtd@lists.infradead.org,
 marcus.folkesson@gmail.com, linux-fsdevel@vger.kernel.org,
 adilger.kernel@dilger.ca, akpm@linux-foundation.org,
 linux-ext4@vger.kernel.org, rockdotlee@gmail.com
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1495398051-4604-2-git-send-email-richard@nod.at>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

On Sun, May 21, 2017 at 10:20:46PM +0200, Richard Weinberger wrote:
> Since UBIFS will also use this function, move it to compat.h.

The name is very generic for a common header.  Please give it a
better name.

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
