From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6 v3] dax: Page invalidation fixes
Date: Tue, 20 Dec 2016 12:09:45 -0800
Message-ID: <CAPcyv4gYeQ+ZjJZU07Co5OHvgPsdU4vmYPOfUyMxJTqmMRktnw@mail.gmail.com>
References: <20161212164708.23244-1-jack@suse.cz>
 <20161213115209.GG15362@quack2.suse.cz>
 <CAPcyv4giLyY8pWP09V5BmUM+sfGO-VJCtkfV6L-RFS+0XQsT9Q@mail.gmail.com>
 <CAPcyv4jqN+GkO7pL0QE0vM50MmqPZ1aD2G3YmziKvp+4+oh5gQ@mail.gmail.com>
 <20161219095623.GE17598@quack2.suse.cz>
 <CAPcyv4jjLg=Nyxusz5Hp8OaJ9fi0Xf6LHW37jgVbxKoOYHjNQw@mail.gmail.com>
 <20161220075942.GB496@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>,
 linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20161220075942.GB496-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 19, 2016 at 11:59 PM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Mon 19-12-16 13:51:53, Dan Williams wrote:
[..]
> Yes, but I've accounted for that. Checking the libnvdimm-pending branch I
> see you missed "ext2: Return BH_New buffers for zeroed blocks" which was
> the first patch in the series. The subject is a slight misnomer since it is
> about setting IOMAP_F_NEW flag instead these days but still it is needed...
> Otherwise the DAX invalidation code would not propely invalidate zero pages
> in the radix tree in response to writes for ext2.

Ok, thanks. Updated libnvdimm-pending pushed out.
