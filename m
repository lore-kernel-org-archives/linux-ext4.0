From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 3/6] ubifs: Use 64bit readdir cookies
Date: Thu, 29 Dec 2016 18:05:54 +0100
Message-ID: <6ba02247-cb0e-e925-207e-4ea3fc37b9b7@nod.at>
References: <1480629741-18375-1-git-send-email-richard@nod.at>
 <1480629741-18375-4-git-send-email-richard@nod.at>
 <20161229025835.GC21325@fieldses.org>
 <bf60916c-e0f2-387c-ce21-325ad8977539@nod.at>
 <20161229153407.GA29149@fieldses.org>
 <fe46ea3c-ef8f-40ba-f4ab-8dfe8faafb0b@nod.at>
 <20161229161534.GA29261@fieldses.org>
 <224abf2f-c820-5df1-6292-42c1e2d47933@nod.at>
 <20161229165920.GA29744@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: david@sigma-star.at, tytso@mit.edu, dedekind1@gmail.com,
 adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 adilger.kernel@dilger.ca, akpm@linux-foundation.org,
 linux-ext4@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20161229165920.GA29744@fieldses.org>
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

On 29.12.2016 17:59, J. Bruce Fields wrote:
> OK, good.  So the random nonce is stored with the entry, and the hash
> you can always recalculate from the filename, so if you return entries
> in nonce+hash order, then you can keep that order stable even across
> deletes and renames.

Yes.

Thanks,
//richard

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
