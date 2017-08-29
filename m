From: Randy Dodgen <rdodgen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Date: Tue, 29 Aug 2017 15:07:08 -0700
Message-ID: <CAC9jV4p62Q-6FnPumac1mASK-PYjyAbTch0bzwWPh3W-dGdsVQ@mail.gmail.com>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
 <20170824160144.GA14287@infradead.org> <20170829212002.GA2154@infradead.org>
 <20170829213721.GA27686@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Randy Dodgen <dodgen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170829213721.GA27686-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

An xfstest is a fine idea. I've started some work on that.

On Tue, Aug 29, 2017 at 2:37 PM, Ross Zwisler
<ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> On Tue, Aug 29, 2017 at 02:20:02PM -0700, Christoph Hellwig wrote:
>> Randy, any chance yto at least share a test script so that others
>> can wire it up for the test suite?
>
> I made a reproducer for my testing. I'll make an xfstest if Randy isn't able
> to.
